class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cdb.cr.yp.to/"
  url "https://cdb.cr.yp.to/cdb-20251021.tar.gz"
  sha256 "8e531d6390bcd7c9a4cbd16fed36326eee78e8b0e5c0783a8158a6a79437e3dd"
  # https://cdb.cr.yp.to/license.html
  license any_of: [
    :public_domain, # LicenseRef-PD-hp - https://cr.yp.to/spdx.html
    "CC0-1.0",
    "0BSD",
    "MIT-0",
    "MIT",
  ]

  livecheck do
    url "https://cdb.cr.yp.to/download.html"
    regex(/href=.*?cdb[._-]v?(\d{8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a5fc9ffe9771eda7b963529031a5e4b057107986e82f4eb308598dc5b1b2f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a197b2cfa575c457c471b9350275722af1df1e8069dff1f9882e7bbf38de11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d7ace2596ad6fbddf67805ac02b1a73a88061f211a4ff0a6cb09dc780560a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d05226d9ea8c84329023b2eea1e254002ae9420b26fd18eca3a9bf06d97c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64b825a879f207b859eec04f96b8ad373848526285e9ef3279ba044b79bf969d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867db4ee654eb1fac410de5933f2ea5b98d18efd6c3e2d293fb15f3886633a01"
  end

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make", "setup"

    man1.install Dir["doc/man/*.1"]
    man3.install Dir["doc/man/*.3"]
    prefix.install_metafiles "doc"
    rm "README.md" # install doc/readme.md instead
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert_path_exists testpath/"db"
    assert_equal record, pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0)
  end
end
