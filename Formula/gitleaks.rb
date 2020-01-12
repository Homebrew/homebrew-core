class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.1.0.tar.gz"
  sha256 "f99fffe5fe4fcca3c7fc561883d3501c55698a886ec06bd77ae64b6392a188d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d60b3ebc7973af2d0e4ab770ddf7bdf75a85ec4dfe79af51a2f50d5c89ac611" => :catalina
    sha256 "74d03153fa0a4ca5b55d5f5cb95b894c7c40adfffb545d7fade402494279218e" => :mojave
    sha256 "8889814db9493ffbc4ad21b96002ebb5a3adb0b4d9a963f4b52ccb90e9aa16dc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/zricethezav/gitleaks/version.Version=#{version}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"gitleaks"
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
