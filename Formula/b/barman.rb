class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://pgbarman.org/"
  url "https://files.pythonhosted.org/packages/eb/8c/b225bca1623a6370885f005e2f575f5f13c5c790eb9bef6695299efca4dd/barman-3.20.1.tar.gz"
  sha256 "cac6542ac7a8f7cf2a7892807509d78dd24346a021afc24a7c3ec5b1626cc636"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/EnterpriseDB/barman.git", branch: "REL_3_X_master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5731864b3d91a264c33711670e4d1e10ebd34e675dd80fb214f75ddf9a37115c"
    sha256 cellar: :any, arm64_tahoe:       "ca40b495693abb0b5d4c1b410a457e5eae9e9ecfdf47a0c1a1c0a25d55654bc6"
    sha256 cellar: :any, arm64_sequoia:     "c4f8a3dd2ef4c6cf6eac867800988f13bcf8aac33bb385a5574f8c9d7c7ceca1"
    sha256 cellar: :any, arm64_linux:       "1bb1e852137a2d944100f7ec2a4fb25abc19f64d97750758556a7a1b222f2162"
    sha256 cellar: :any, x86_64_linux:      "12c46194af868574bfc7336c25f033cfe7bbb635656997bc8f79ca3989c3bbb0"
  end

  depends_on "rust" => :build # for uv_build > maturin
  depends_on "libpq"
  depends_on "python@3.15"

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/91/81/6ea19b8b28feb9405c8c87a307776614d6e404bdb98467d1ce10a39d2c1d/psycopg2-2.9.13.tar.gz"
    sha256 "d36784fc2dae69523ba4b79c7d1d1b4d6e83e87836874f111262f4db940b16a6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    virtualenv_install_with_resources
    etc.install "docs/barman.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/barman --version")

    cp etc/"barman.conf", testpath
    inreplace "barman.conf", "barman_user = barman", "barman_user = #{ENV["USER"]}"
    system bin/"barman", "-c", "barman.conf", "list-servers"
  end
end
