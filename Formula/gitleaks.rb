class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.2.0.tar.gz"
  sha256 "c4323390f4bf32177613aac4470cc58c54b48ed1a70209f28011f86f2997eab2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e09f54b47fc6ba5cf7acac50d8dcf0f02a32c1586a1f14ae1a0882dfd040c6c1" => :catalina
    sha256 "71dddb77399f32ee00b0cc5dc37e777dbe84aa3506d655281dc148c49d6fdff2" => :mojave
    sha256 "0ef4358a423555e207abf757db4c991a7e5a1aca1451dd07ee4040c364291d10" => :high_sierra
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
