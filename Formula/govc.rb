class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.2.tar.gz"
  sha256 "eb6968e42e59eaa7f41ff5c710b6df4e2fd0c1863215ff7bf1aeaaa31a68e1fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438bea9e82d253e45752a39fdf516259d943decefd727b450ac486143f27d8af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c10759c02362084884041b725f6e061f30d199a42b61b56ac8bb1adcd66ec14c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5392796ab97ac5a1f3df27b6f957dba55014128eba18497b88005b2ac6d440df"
    sha256 cellar: :any_skip_relocation, ventura:        "cd13ec8955a2117238691c2233b05f4b003611d9fe30824090fa2edf75acc727"
    sha256 cellar: :any_skip_relocation, monterey:       "fada5d52b00b8f767e4d464c15902e93dff9e357de7760e44c05f60b259a40fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e4cb38d655aa282835a4ebba9e68e283fd9cf6862a50edead7b53e4f488f33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d62e7a2cc61becafb5feb547926040a9180389507a5d693770fde0ed987b959"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
