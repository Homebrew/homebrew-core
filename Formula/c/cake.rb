class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "32e93073526d1c65d298d573a33b23d908484bb37fdd68b66bc36a9dde7921fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7e950f55d377f780683ba9a1123a7b009aa8ae938ba97195747b7d24ae1fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c34254b7a1f561b3b67f465dea3505abf761a989dde7fb4d37780b0f3e9544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccfac27859b9dbedd76d793cd62795d05e2c9a38ae039b604a502744f9245798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f80802dc899b201d304a2b137878fafc03c4315b0d0f326689b206f057b54d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eadcc16ddfb3c38cab715f1d0fbc9b280dfa21a82995dffd5a4f144b8e5759e"
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
