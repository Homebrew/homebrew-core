class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://pgbarman.org/"
  url "https://files.pythonhosted.org/packages/41/3c/738de855112d6d6b305aaa235ec6bb1059d968a0f6c49792a3a91019db6e/barman-3.21.0.tar.gz"
  sha256 "962108f674177f3a457d8f73cc7d545d4a1db1de5c5b135e1104ef12e1217275"
  license "GPL-3.0-or-later"
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
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
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
