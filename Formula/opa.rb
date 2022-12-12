class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.47.3.tar.gz"
  sha256 "2b5e577fe2f7e91e64628b7cbccdb33cce94baca1f669eb396db2edbce255789"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c69e65196edbc0683c1c6b5e02c795c6385c1b47a7b7769276b5239e7e7b142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ab34bac9221d29892df63ad63ed657e3a294bdad6b11bc040cbc0a7f851511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc782ed031a4c15b4fcdfcfc0f5040b9ac10700035c5ee35d6ff5d0099f568ae"
    sha256 cellar: :any_skip_relocation, ventura:        "de83e848453ef1d67e888f851e6496f30477c2416be98456322f323d60503188"
    sha256 cellar: :any_skip_relocation, monterey:       "4c9fdca5c2c7674bee12459b0f2c46781a2be87e88559a4a08cf1476c2b6f759"
    sha256 cellar: :any_skip_relocation, big_sur:        "21b20abfc7e0b6c01faf310aa87032e5daaf3f6bc6aa0ffd4b694c640cbd2f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3864f8dd15f19a988048fd61a10fa9dda86320441a693ec5c5a4918a2a73172a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
