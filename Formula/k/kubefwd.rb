class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.13.tar.gz"
  sha256 "a82b9bb8d6e96cb1f1f3087b3079ef6bc5cc2a5a09713eaf959fe608df2eeb30"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef694f943b081886b02079b60581002a185fe67470485616c4001ec68c8922b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a4bf5b4fb5b690fce6925f02a29f29fecf844a7718f98a8aae913df791420a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c3d2450c227875054d4b41299a767e77483b9044b079ff051b09ba4af970e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b308ca45d76c2fe6fa2170af36f11d1c9320c5eb24f310af608cbe98544cb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2954c48d048dfd3de4068b62a8c09ec2a7098957e9cd5488afef97fc70468ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "074929ab6477ce1a1a10e852b2337a5a27114f203b3d7a9dc8f970ffaad0227e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubefwd"

    generate_completions_from_executable(bin/"kubefwd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubefwd version")
    assert_match "This program requires superuser privileges to run.", shell_output("#{bin}/kubefwd services")

    output_log = testpath/"output.log"
    pid = spawn bin/"kubefwd", "mcp", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Cannot connect to kubefwd API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
