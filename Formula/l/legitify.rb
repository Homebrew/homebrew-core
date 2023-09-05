class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3095524885e073954d0d9b89bf468a69c8e2bebf982cdfbed50f06d7964263a6"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a92a1ddb8ae86d3b8a4338bc7cc6c9d732735871d6c2a6acee75522f63e5df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45d29538e4286db5b2183f681a57bc47680695e0d7efecd002f36fdf59d1670e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aaf0efd24e7dbbd86993576ebc448d178782452d9bdcfc324f47f0a03e64d14"
    sha256 cellar: :any_skip_relocation, ventura:        "938fe1279aec5442123042c6b240e598c51384de118cec48b51e0dedb570e1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "cf8dab3a355f44013d52194a47f0260ebe3e1f26f5712a6db07cf2b7674e50e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "601b607bd73fc4e9b41f7f2f04d0e66c9e4997178eaa13c39065c69dfc5094aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cbdc057d77b24f734d4e415945023bef229af9d34af2297aa0297039f62bb14"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
