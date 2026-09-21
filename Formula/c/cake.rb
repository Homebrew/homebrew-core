class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "6db077c1a78323dce1b53a799e5c53ed4d864dd4f6c6d206d46e5d71733e3dcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eab86942aefd359d3492bf7ab0e634994ef5077b9663cdc5ab18022d0be4a21b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2035b88305f7e1b4d6f600d152715ccf4384e67257e48af96a20005990d14a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03a1dfb9fb1d45c686d239b2f3aa7ab2c2c0bd2ae5b2676f1ee79839cd94680b"
    sha256 cellar: :any,                 arm64_linux:       "75a1e6f8322a7320f6046cc739be111931e6516f9b9b72f87de49627c65b7d0b"
    sha256 cellar: :any,                 x86_64_linux:      "49dadedc8d28580466aa31f021d0c4f22c24adf1ecfafc83aeb5f67ee532f3a6"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

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
    assert_match "Hello Homebrew", shell_output("#{bin}/cake build.cake")
  end
end
