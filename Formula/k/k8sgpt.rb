class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "ab6b4d972bae20bfa180b1ba2975972ad5769b2f7ca2725ec7119a4cd07c14c7"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "402714b4019231590a95a17624a3536c26557e04a2098823b85b8174472cd603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f92a0550f826633895cde1b1c3d9bb3f502c1f3c979c2fc3249929e1c09717b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c63c2860d4c8981c17d0a31d7e59f7e79d93755c8ac2a7366a7e0e95714b4331"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a2ce82266fa4a0a17b38bac4af41362dc5160d1628191ba0c5fd19e51373309"
    sha256 cellar: :any_skip_relocation, ventura:        "6861957d5e3148b044caf8cf6befa365a852e946c952398aadca47fa66c3d445"
    sha256 cellar: :any_skip_relocation, monterey:       "4a84ff1b4b2c251ca309832112c8fe3e507a1295832fb1d7695a77527948dfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb190373919ebbde394c80ba51a23a1cca265e14786e9d0e3a4000fda65ae1db"
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
