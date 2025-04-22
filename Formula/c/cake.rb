class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "0c77a4a8626b1f6aa886e542026f33e2645bda7177e66c6ca1f60a6cf80b9bf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c022a53d5c794a02cb245365a20e68101ff498636aa9d9b0d5791df21e6946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39611171d03f29228d6c0f1402647d20a7ada16eff8a8c9fcd25c57d8ce5b7b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37df34c69614dea7ac08ea390a065de5765df3117ab8b7bf4d76135d9ec3ab3e"
    sha256 cellar: :any_skip_relocation, ventura:       "9d076394489c1d9004fb0749b3723dde1fd951a1cb4f7f81672e83c82680fd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c28f268ba6ef8a1f944a6f722b47cf0b210b7c46dba41ecff0e85b83ce55f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9790da9b120af327c140e99edb3d8bd88fe07016045863938915193f376494b2"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Cake", *args
    bin.install_symlink libexec/"Cake" => "cake"
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
