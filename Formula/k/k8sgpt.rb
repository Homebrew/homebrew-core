class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "f70dba746fa2e54dc1876d1b5115b3c3c996972284e3a87bad89e7ab2094f7f4"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69257b698577fe2b567947a659aef406951a9532c53ef23e336874d2dadc669e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac8b6a973cc0b2bd7203c229f3b5e3e0ec910e87e12ebd98e40652477a4f8afb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8846c466a7de11c24e7a8bc334470ab15304b3aa8140a158ffc5d6525bb0b891"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc04773697058582bef59ccac1ff00674bd3ae5c905deacc91f25e6f4533d03"
    sha256 cellar: :any_skip_relocation, ventura:       "a58d58fbc2e4713685920f198160a046882d3c64de38c9da16f5355b3ff2f3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551c255afea0d7c6332e353d97f11d2bb6e745c4b9739a1072521d29a5d97c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec204403dd07a54b8ff215685f769c73153c355bd04fefc7e228e2767d14ad26"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
