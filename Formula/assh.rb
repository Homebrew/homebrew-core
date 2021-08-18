class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.11.3.tar.gz"
  sha256 "da95db33f72ad2531124b0de42074ba61ac1eebdad90bac90c68d1b02aa51354"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0860549309f01ea758615ab322bffc4599bc18e57122f7cbaf307bd3ea97a5ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "38f180a404deea504c730e59c9c4fa867f7af1c01558d64a891cd2803bf7777b"
    sha256 cellar: :any_skip_relocation, catalina:      "486b60df723e01996d1654b53ff9ee8ff46d02500290ceb35a42a1aa8fdf22f6"
    sha256 cellar: :any_skip_relocation, mojave:        "0432605530886e05a3bae571cc33c0ae4043e8f7616fa7245d6d352bf54e2a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ec8e46957e373a14f9ffeb262a0bf89792a153da6ed34f7d58b2e0c45f0931"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
