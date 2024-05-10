class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "096b234fcb6abfce3e3cf82051719f31d8049b29a842809f183379899682622a"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0a2745e600c0bbde4503f4e796d6f5b6465edbeab804bcdb413c8f32c5f414"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce92f7a6550065a63084a1bb564b5b78a0affbdfe5d10e931ecb462c369fedb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bbe6b893b247706968a94fd25c444e484993f3f2da1a5605ea76b8a6fcf422"
    sha256 cellar: :any_skip_relocation, sonoma:         "46f05bda694796e776a7f064488d5f4c7a7e492e52de09efcf8caeb9699ec0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "a63d001b78564b4b36c3400806013abaff33d62abdd823528533a2612c6f7ccf"
    sha256 cellar: :any_skip_relocation, monterey:       "ae807c876df1164b77c70bcaa520448e24f0fc86db4f2cf4472c1e036f6d1f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee99dd2f79a21ab1ee5523b945a1d5f1e78b55fd0d7418571f2f690196aa2bf8"
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
