class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "e06254767dcef13a16f8b3ebda3cd9d3838977e1d12064c78114bfa741482f25"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4362247aad89da15626c901f2731b088b48332a8a6808e88893850882eebef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874a4d01b76f311de2058e552172ed6efaa81dbe3c45d77f938840ffdb7ff49d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebfa8a3d4601cf9a201e9e6ce40df495a0071d9cd6b880a053d11bc9c551ab4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "329e8ea41ea9fdaaa823332fdb1eb85433f2e9bf7391f38ba94f9b5ddb53299a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0aee5e30ac6815146bbdb78f30a61d90744dbed1392904a9bd51a0b8dcb474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f757fca556c176caf63b7132d109deda34659daf282816154024002837023c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
