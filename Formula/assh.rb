class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.12.2.tar.gz"
  sha256 "bc22b229cac9f5c1f43b534788cfa0a024b6b70ed62eb215f81d443d571e10e8"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30be296faa0a138b81486bdd3a6cd885fdf7807c944aae1d7b7ed53fa0f7fdb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d104eea6feedbbb5f94c88cb134ff42ac0d7d2bc51cdc3319e941807fa0155"
    sha256 cellar: :any_skip_relocation, monterey:       "6db39cf5878d81d48e1075d07e64e26615f454db33a60ac39b3ebbda80e99f13"
    sha256 cellar: :any_skip_relocation, big_sur:        "161366bff34f651097fbbe6bd182067cfcb24b37572237f91ef5c0748cf5e33f"
    sha256 cellar: :any_skip_relocation, catalina:       "5346fbc61136dc4ad80fcda051669a45cc0334aa9005dfca2fa547e730ea54ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6615d9f78af09e09968affc05689a8f00c4a8454d9c008ea1126f461d43186fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
