class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.100.0.tar.gz"
  sha256 "d4f1fa35b6911c4a3fcb9bb8723e4ed6724c2aea71813dfce49ce65aed20b57d"
  license "MIT"
  revision 3

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7224e7b6b24b34cdeb0e0186a3853d58cf987d0ef967c7f3b44efda6c9888848"
    sha256 cellar: :any,                 arm64_sequoia: "196fd41886378a073bfd4f8bcbf9a658b67b49aa6998b4fe4595315e926067b4"
    sha256 cellar: :any,                 arm64_sonoma:  "758ec341fc2dc881d54b0165fac1c7aae111e194a2b43c20b5d84eccf9a33985"
    sha256 cellar: :any,                 sonoma:        "0172382b8574a84ed256f501694288f0def9d8dd1e405d073097883e56dcde96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71155eb9fe36336158a2f1a69b20a8c1cb763425b56b615576fedd9d1c67d350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afaf1c4c95277a8f8bf28c0f5c3be607172a23f288bb1b69bbca21ac01d91f57"
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
      exec "#{Formula["dartaotruntime"].opt_bin}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end
