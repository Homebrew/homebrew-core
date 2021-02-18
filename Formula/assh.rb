class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.11.3.tar.gz"
  sha256 "da95db33f72ad2531124b0de42074ba61ac1eebdad90bac90c68d1b02aa51354"
  license "MIT"
  head "https://github.com/moul/assh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b6d3bd7c93bc22801b7d14ccefdd58e4014d0b29441d4f321b5c4e3332220b1e"
    sha256 cellar: :any_skip_relocation, catalina: "43248132ae1cb81c554834afa0e0fd5ad4507e57aa54f7596fe7f0f5ab9821b1"
    sha256 cellar: :any_skip_relocation, mojave:   "9c228764205ed2cd98f80e7baa13397f4cc7f944370498b42048f785e8366778"
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
