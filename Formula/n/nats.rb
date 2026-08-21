class Nats < Formula
  desc "Utility for NATS Server and JetStream administration"
  homepage "https://github.com/nats-io/natscli"
  url "https://github.com/nats-io/natscli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6dc9056aa439f90de2a705983005363ae05f1f9985b81881cbfffa867a344ef6"
  license "Apache-2.0"
  head "https://github.com/nats-io/natscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed76909dd6173fb6080410ac2b0c600d5a380e01ae1c86d0508186a97a71e008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc3c11493c0c6ab49a7274d8e5c4a817bfe2ef083a57966982afbc7321ac37c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b449507a6e72777e9ff0134c433c399e588e9606e06a674ee070240b48bb5297"
    sha256 cellar: :any_skip_relocation, sonoma:        "0854f3a3ffded7e6faae8ee778596d34df27f487fc55974c7bc836318843634d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d566e14d2676997b9779b2158589832c248969ce8921c63012fb2c79d74f8d"
    sha256 cellar: :any,                 x86_64_linux:  "db2b2a103154f64077c04de5971255647898afa12907d71a7e7672bb619859d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./nats"
    generate_completions_from_executable(bin/"nats", shells:                 [:bash, :zsh],
                                                     shell_parameter_format: "--completion-script-")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nats --version")
    assert_match "No known contexts", shell_output("#{bin}/nats context ls")
    assert_match(/^[A-Z0-9]+$/, shell_output("#{bin}/nats auth nkey gen user").strip)
  end
end
