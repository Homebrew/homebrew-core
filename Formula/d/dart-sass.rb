class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.106.0.tar.gz"
  sha256 "1df149f8b194f03511290a1869450e947c4551eebfb9a398793a7f86a79b1d99"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6997a719e8b98a4783651503cd22f240942768bdcff29ac486dcee5ddd48e732"
    sha256 cellar: :any,                 arm64_tahoe:       "eb2d9a098cb1ee187b8e8e8f238bcaf481df18aadcb07a76f68cc81307a8a895"
    sha256 cellar: :any,                 arm64_sequoia:     "ed0f6e6f6bdfbd6267b2760ab846af1d9e4909206401256277aabb9a325d3c61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32b7b076acf7ee2c1ee957e56efe42e3927e07403f5b98c666433be39a176100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5631dcdfef55d640ac759e15f09f9e3c10b3486a8108627f83818e79fbf3cee"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.3.0.tar.gz"
    sha256 "17ea26c8ae3bb03a7dc72f841d7d832b64410230483cdde8807ab4b7f9204ce8"

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
