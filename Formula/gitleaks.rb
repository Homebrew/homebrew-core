class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.1.0.tar.gz"
  sha256 "5b38829329711504ec485199eea113a77fb3686bb0b587beb341ea67026d4872"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dae1e203f8adb045e7d32bca97a28a4d7c24a0272ea1a92d4320cfa6491bf9cb" => :catalina
    sha256 "f92b46771f04e7c82783a3751a103fcf0e76f1ce926d1fa0c524289c361001cd" => :mojave
    sha256 "ae6c5225b0306722c007f9dff42a9692a9e00e792d3d69adcba898e15353d9ec" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
  end
end
