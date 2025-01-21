class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/vultr/docker-machine-driver-vultr"
  url "https://github.com/vultr/docker-machine-driver-vultr/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d81ffb5a923d521830090025e0b65dbd7bef8b8472a50637ddf80a9f5c31cd25"
  license "MIT"
  head "https://github.com/vultr/docker-machine-driver-vultr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d8d8ab4e64dfad590bbcf625f7a56fd7008f0b673047251bfc36eea093672693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a89f639247bfde26bc01d330a3ef9f9c70ae62545ded4906f04411d50a73ba2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5abc382c4eba9893c4d007536f4eb2821712d151b6350f78b529f13c24959f13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5487fc22b94aa50dba4b89d156bea04041bb6f45ba7620d46c7c1ec93ac77606"
    sha256 cellar: :any_skip_relocation, sonoma:         "9790e258cea564860445b9c9b5508a641d6767ba3c70b34783ede69707e85487"
    sha256 cellar: :any_skip_relocation, ventura:        "386047cf1025dcddaeebcb1573d4e6be8a0d6f1e7b29b971917ceacd58375256"
    sha256 cellar: :any_skip_relocation, monterey:       "389a25674d1d926d409764ec415a136c360038d95473a30c152dce3da724099d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734751b125d0acc75a57ad74f0c585394340dea6010158793622ce0c08277989"
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
