class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.3.1.tar.gz"
  sha256 "0a109362ccc1b773407112c8fa81718c09c861fdefdaa19312316aa4f88ef1e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd93e118160563e46825ee86bfbcedc8894e8799b20a400fe47b4412243f8f12" => :catalina
    sha256 "857d0fcf0420198d43a76ff555a2afb893662aae808711e8deb7d0c7604f873d" => :mojave
    sha256 "678cd5b4d9e592985bb56e4e20a5f675010eb623b7f61aede5290a72137f640c" => :high_sierra
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
