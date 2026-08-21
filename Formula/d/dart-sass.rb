class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.103.1.tar.gz"
  sha256 "21d2f2cb02a87432c756786839e75ee642f6debd6790a0d77d0bca7c6bcc5a71"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "234bb88cb7ce8f87e418b8a050505e440d530309d2aeb2d6b10a4363a0491c5f"
    sha256 cellar: :any,                 arm64_sequoia: "21d7b2261017c6e559dc965b17b5ca0544d9b119d9bac966cb73cc54a9768727"
    sha256 cellar: :any,                 arm64_sonoma:  "2511756aa0eb4f1f83790f423a8609502e24f7c6984d9ff2b02fda515d82ce5d"
    sha256 cellar: :any,                 sonoma:        "354e97fe9fa691c75839e3028e816088780129373281c4a163c3953ef46a1d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "117db5057a45e63b9bd4d9e4382d86443f30784e3d8c45969cd69767ea062c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5265d167760d5b54f7152454286e5f9b492c5972d4a6eb4315f9c01ae126ca9"
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
