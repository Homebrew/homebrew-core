class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.4.tar.gz"
  sha256 "4dd6c06c828eb4b850445bd1a7086e727b4b5003f199613b1d5fbe02e6899628"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b5b25d59d4e417119ea0cf380475a8bbbc37ad5cae72d53afed53063179180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1863b3101a033a1ab8275f1e7c2cc4fec2ecb21f651a3b73143f195673563e49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d1fba72cacf6924fc113733c5a10097b5afd3ecb4ddda10ecd53759a66ea594"
    sha256 cellar: :any_skip_relocation, ventura:        "ce33157a31b5aa8be57f04dac37bc32e5f5a94f9ebdcffed45c1e26ca3d9cc7e"
    sha256 cellar: :any_skip_relocation, monterey:       "123172c6f7225b74a07382ec56932edb08514af8a7e0e79d71117fa54f108738"
    sha256 cellar: :any_skip_relocation, big_sur:        "b00147d355f1fab8274136e6000aa9e4df9970d5aac9c1f9df4659079564910e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c73641f88e55375e3ef1b7dd906d2c829077dde1952660a8c7a3876c71a302c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
