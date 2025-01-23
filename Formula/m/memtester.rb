class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "https://pyropus.ca/software/memtester/"
  url "https://pyropus.ca/software/memtester/old-versions/memtester-4.7.0.tar.gz", using: :homebrew_curl
  sha256 "33271805f8aa30c119fbbf5ec4e7a298e9f4c2bc9d2d9302022a3ed301eb7028"
  license "GPL-2.0-only"

  # Despite the name, all the versions are seemingly found on this page. If this
  # doesn't end up being true over time, we can check the homepage instead.
  livecheck do
    url "https://pyropus.ca/software/memtester/old-versions/"
    regex(/href=.*?memtester[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17a57953082eda2a4efad8ce3999a3e939e34eb69b70809d2636c0869e3ebb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c24c6b00dfc86a11edeedbab05eaa2b9ccbefe5712cd8c79f6f8d6b4603249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb67620bcf7242224227ec13c0dd5cfae4968524d74d9aa40cfe7e219bcab0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a698b2e817b8e1f7a6d72db8ca7dd52b8a1ab4cfa7b1cbbc6c0ff35840635e"
    sha256 cellar: :any_skip_relocation, ventura:       "2378767f21fcd8cb8024c61538705490fcadb608c7c0443f871b55f200d62436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef916295490ef4ddb3936c6d3a26275af440a6a333b1407f227fca4a6ad03b23"
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
