class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "07601e265a526b852fbffe02f763beeace0ed21d53cf6b9ec44eb5b299afdab6"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49796813bdc9cfe15df7e1256821f53c24698a2b6310e4ed462ab74423588682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa017c27107ee10eea0d82dadc45fab7db13556e4e0341d73a812c865e91262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a45bf025508ed94d0b792a755f0365059487104b585421760d9c0b4d2b1eeaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "83999be9ced1d959addcfc6c5a556dedef64413ce813621484b3217ba9e99e55"
    sha256 cellar: :any_skip_relocation, ventura:        "999e3dc99744ce2f57cab30d8f4b15bf7ab19c3c0fb554c366ea8e816d88b509"
    sha256 cellar: :any_skip_relocation, monterey:       "0bc31b0a9d7db94821e5ccd48edcbd5889184313f1aa29834ddc44ecda0f7524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d1ad5473e9a9b967afd1b6a50d032c5e889813bdca6ec5673bafda4a4efe87"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
