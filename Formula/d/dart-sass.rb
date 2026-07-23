class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.101.6.tar.gz"
  sha256 "bc4a298adb4984d7ec0ee1561a4d7520753f42be8e0157a161e57ce3990033c0"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5b0b59a91aa195ccee3199af294eb1f2d1f3b57a194f3a7183047e7d7925e33"
    sha256 cellar: :any,                 arm64_sequoia: "88fe66e717b5b5fbdff9adf0a8594dbdd86ea86a876c72e062d82f6b57a36c24"
    sha256 cellar: :any,                 arm64_sonoma:  "fd74b6a179ddcba901e2d272844bacba0fcc9378df2b134203ee4e1da441cb97"
    sha256 cellar: :any,                 sonoma:        "4f48347c96c181a7cc4dd724d6a92b8c68c3c7003dceda4edabba7f3d2249558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12798f095fd488021a7451ebab18cd3a1b27c8e9ac69105d5f2db8f5bf0fbf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab930654eca6600a5d4facc905bd492e75d13a1dced4ed202448c2781b908baf"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"

    livecheck do
      url :url
      regex(/embedded-protocol[._-]v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    args = %W[
      -Dversion=#{version}
      -Ddart-version=#{Formula["dart-sdk"].version}
      -Dcompiler-version=#{version}
      -Dprotocol-version=#{resource("language").version}
    ]
    system "dart", "compile", "aot-snapshot", "--output", "sass.aot", *args, "bin/sass.dart"
    libexec.install "sass.aot"

    (bin/"sass").write <<~BASH
      #!/bin/bash
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end
