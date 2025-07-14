class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/vultr/docker-machine-driver-vultr"
  url "https://github.com/vultr/docker-machine-driver-vultr/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "5616de789503c56e1da38df238e3920d64d88728e401054a229580bf3e310108"
  license "MIT"
  head "https://github.com/vultr/docker-machine-driver-vultr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5c031493451ee1fd50f8b330c9aa4bcad771c3313057a57e191bf0f7ba8ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5c031493451ee1fd50f8b330c9aa4bcad771c3313057a57e191bf0f7ba8ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe5c031493451ee1fd50f8b330c9aa4bcad771c3313057a57e191bf0f7ba8ec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "083a588c686e1ab4b850bed47b0dcc5b9de91c94165a05216fb2119766a5c736"
    sha256 cellar: :any_skip_relocation, ventura:       "083a588c686e1ab4b850bed47b0dcc5b9de91c94165a05216fb2119766a5c736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcce498ca4b19b4843339a7fcc14dc039a38bd3083534eeb5fd42d71facd9ff9"
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./machine"
  end

  test do
    assert_match "--vultr-api-key",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
