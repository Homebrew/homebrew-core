class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "cdfe2444b684d595c1f8644828b244540402c8ee09f6fef6db1e20eb3d933617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363b0fb40ef39f2a538a1336ad6795c1af5ea6a66d65eed78344589611b86c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f88ba04ced2ae43530d71bafe7aa5a036d1a736e4aa1689481aae819cee6fa8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6bfa4b721c966a17de14031ffc8728fc77e2871a6c96396923478cea2286f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5aa9eba65850f571e205def25d38c513042ee1cc491b930377a049fdc2a657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d68ba96ae941580e13c6236b30621a3bb308ef6bce284d94868063b183eed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a2277936286a61f1abfbfb22ed9701d4c7c1ac7bdd96bb2a44a5edd99deafe"
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
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
