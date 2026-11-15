class PgActivity < Formula
  include Language::Python::Virtualenv

  desc "Top-like interactive monitoring tool for PostgreSQL server activity"
  homepage "https://github.com/dalibo/pg_activity"
  url "https://files.pythonhosted.org/packages/6f/84/bda632898fc04b3d89d0ab3863e8aedad90b01c19edf32f45d48fe21dae0/pg_activity-3.6.2.tar.gz"
  sha256 "82ea53a0eeea1fa8015e5eb9d1d1501431e3308e9ee65a7d898d9bf75ba3620a"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbc86bbcf4f8d597da51680be64538106333f5526aed945f09f2b62263ceed02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39b1c3a579e0ad780c13140b9f1a5a66a552cfb0a04565f204a37cb9d74c6a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7225c666d8a8d43ac5c9afae5221195922cb3babb09fdc09b1f61e9c4a461a2b"
    sha256 cellar: :any,                 arm64_linux:       "99cadc23243fb39c356648fa45effaff5ef1a1bc981a3482cc42b9537a5ae1a0"
    sha256 cellar: :any,                 x86_64_linux:      "302a9ac85e09851f953bfe571a18202ecb6e7a00d96f91152a5d79b1fecad26f"
  end

  depends_on "libpq"
  depends_on "python@3.15"

  pypi_packages extra_packages: "psycopg"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/7d/44d82d953d9bbcac57fe26507ea7ffba65ef1ec8f41f2b58da2fb12ef26c/blessed-1.50.0.tar.gz"
    sha256 "046c9b2a5283a9c5bc340ed23b7d1c1f10ef2d7fb30b14bae13ef7ffc1f3ba56"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/76/26/3ea4ca5eaea1c0debcdf7ee7c1613fbe721dc27a03c461c0817ffd8a0601/psycopg-3.3.6.tar.gz"
    sha256 "c081f2250df751a943036e42db6df4571c66cd0aabe8291a7a506512b12007d2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    venv = virtualenv_install_with_resources without: "psycopg"

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname := find_libpq_full_path()",
                                            "libname := '#{formula_opt_lib("libpq")/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    man1.install "docs/man/pg_activity.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_activity --version")

    output = shell_output("#{bin}/pg_activity --host #{testpath} 2>&1", 1)
    assert_match "could not connect to PostgreSQL", output
  end
end
