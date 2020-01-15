class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.1.0.tar.gz"
  sha256 "f99fffe5fe4fcca3c7fc561883d3501c55698a886ec06bd77ae64b6392a188d4"

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
