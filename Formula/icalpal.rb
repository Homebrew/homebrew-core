class Icalpal < Formula
  desc "Command-line tool to query a macOS Calendar for accounts, calendars, and events"
  homepage "https://github.com/ajrosen/icalPal"
  url "https://github.com/ajrosen/icalPal/archive/refs/tags/1.0.2.tar.gz"
  sha256 "435cdf4098da06fa401e7abf40c1be28d0758f3f399bc2547e59bb0d80263bf5"
  license "GPL-3.0-or-later"

  uses_from_macos "ruby"

  resource "testdata" do
    url "https://github.com/ajrosen/icalPal/raw/main/test/testdata.tar.gz"
    sha256 "298f95ce9d54c7434602bd6f3bd22aba67cfcc8cd14ddefe1549cf71a7c6edd4"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    resource("testdata").stage do
      ["calendars", "stores"].each do |t|
        system "#{bin}/icalPal -c #{t} --db Calendar.sqlitedb --cf /dev/null > #{t}"
      end
      system "sha256sum", "-c", "sha256sum"
    end
  end
end
