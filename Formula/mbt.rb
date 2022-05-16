class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.13.tar.gz"
  sha256 "41ecfe2b7d91ce757cf35509c75b90e8bd90f7248ae781d25216f86f145416a0"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f994f70a2c287dcf97ba828272e4c9e635391ab17520da0a477d493b4d7a0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c931394d506d969ef608f7c034d35d7b4fd4ccc4dd2c64f0e715f03cc9d0dd1"
    sha256 cellar: :any_skip_relocation, monterey:       "c03f19206bd48baaf55cf90892ab76b338386763be4aec86038fdf4409a23477"
    sha256 cellar: :any_skip_relocation, big_sur:        "e42e96f7bb7062c1caf4f25b019e8120951580470f0dd4cf6ec9e007c77a5ee9"
    sha256 cellar: :any_skip_relocation, catalina:       "27f6c41449d35590475614cc3c2db9a9364d6520a26e44a6a647a2a7c1b49662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b5154a0acd2ee1b1a6aafedbf82a213a883ccdb5f3edbff1fdb96697591952"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
