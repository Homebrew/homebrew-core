class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "48d7546ac270941be1f3628962201b64b3ab8f654c2e7c4b84d3939b4feb5cff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4324a921f28ffc1b9fc425e0fa5c5e77146956b24160844ad869e0faffa0d035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4324a921f28ffc1b9fc425e0fa5c5e77146956b24160844ad869e0faffa0d035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4324a921f28ffc1b9fc425e0fa5c5e77146956b24160844ad869e0faffa0d035"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e2211fc1c4e507d447c34e40abb14df01dc9afe57808f2f0ff914c3ef53329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4696a6ce4d9e81e1ddbc7372aa054a6326043af7089689759463a6a9376242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b02388cf42314eafcff3ae5b51b01455c2a99698a574e73bdc42562c0351dac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
