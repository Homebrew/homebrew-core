class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "5fe61d9df142ef8c1d15def04dc3a634f07459f0ecc6098efb760207ddc6a452"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66aca50add4eb13e63791f5358f4cb88df0090dad8e259a1f5fd4dced99d4a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fb46fcfcaa4a522f3b3564d1e0c12ce8bd88c43f51415c92d01d8c2fda2c8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e01b123fa2ec64278de8b5240e5425ab6ec1d7f07465687d4d63419ff0112c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0910f94001d5073311e780ebc5aaee94e48617467e1578480c82991d8fce486d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a272a1691e03fecf254ab324a9a024d0cd1f420edc356661f593571852dd2f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2012a88e489d8d3f680a975c66f22a8ecfaad8ace90bdcc222530c04dc075bbb"
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
