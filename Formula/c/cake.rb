class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "90c172d5ca8bd3b274cb7cbadca0a4de7f627663f2915c3ac33fe99ae7937f0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "207852e14fb8ef1856aac7e6e73639eb214d1817d8b4f1c3f2b9034896c35d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6d9e97185b565f36bcbcc4237013ad62a2bf76f6fa542f9d802393fdb44bed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf6a9e84ead686f41b801737a919f18587012221ce22dbb8df1f9a8cf47573a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c06c9bc2cedf9e8f85dbf53a09cf05c169aeaa9520f84b8c2d5797a301ca7e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "162608928ded9568ceea964a9ce4ffde2a87220f9343c3f8d1d87a89e067097e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82b8d10fcf983f195b1422d768f9fcc1b2d49de038c906043846084f3104e0e"
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
