class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.6.1.tar.gz"
  sha256 "316b418ba0bec92ff427a71146eed414440a955d697b63ee593203653d8771de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e64bd5ae986004fdae3e884a4e61c724a8d4ebc42ec8b24c99401a6f81ca8707"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b42974566e498578a41dffe841ecd15400d7022d46640da1f573e05f6a54c9f"
    sha256 cellar: :any_skip_relocation, catalina:      "6c0607aa04d77d0ebe89f60a73a04c89640d9ee077d7601d1dd3a8ee0e0afce5"
    sha256 cellar: :any_skip_relocation, mojave:        "e5d16e9a79762edd9945aa07a5d3e6bb7cf2278145d7d52faab1117f63aee646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcc7a550f7d8326ed82c310b234ef45a0e03b655253de6ebf6cdd4b67622c60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    output = shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git 2>&1", 1)
    assert_match "level=info msg=\"cloning... https://github.com/gitleakstest/emptyrepo.git\"", output
    assert_match "level=error msg=\"remote repository is empty\"", output

    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
