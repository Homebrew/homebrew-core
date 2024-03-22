class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "81fac3bfc31f398da1cfa239b4c0e6a0762a953285e5ec9227947f4f72e5a86d"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e1614dd76b1fbde4607d1eff84eea7fed13600eb3d0120cc28384ab5b4ba599"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f43109c13387f1aec93f136894177ad819f8f88f2239d162bc220030ab1b06c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7af042bb7211fa62382fce607d3276534fd5acf539bd276d8ab8e185d80ed06"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44054de97b5cd1232598ea92b504dcd40689ac6bff622bb485ea7bc861af757"
    sha256 cellar: :any_skip_relocation, ventura:        "138168b25710358e4c5c685a7c33704171e3f302019d0f2a9da90b9e1071a9c8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa0305c1391a5daa2d817bdf7e6a4b64d81a6592eba31466697cb50882e7de3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d22571cf2297835afc084a43ddc2b2b7a4d139964a735c79470c855716d9c4c2"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
