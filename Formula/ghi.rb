class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.2.0.tar.gz"
  sha256 "ffc17cfbdc8b88bf208f5f762e62c211bf8fc837f447354ad53cce39b1400671"
  revision 3
  head "https://github.com/stephencelis/ghi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba94f49672f3e2e16250d421805cd931a8cdf99c5c5eb2f53012047fca5a5b82" => :high_sierra
    sha256 "ba94f49672f3e2e16250d421805cd931a8cdf99c5c5eb2f53012047fca5a5b82" => :sierra
    sha256 "ba94f49672f3e2e16250d421805cd931a8cdf99c5c5eb2f53012047fca5a5b82" => :el_capitan
  end

  depends_on :ruby => "1.8"

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.12.1.gem"
    sha256 "b387722b0a31fff619a2682c7011affb5a13fed2cce240c75c5d6ca3e910ecf2"
  end

  resource "pygments.rb" do
    url "https://rubygems.org/gems/pygments.rb-1.1.2.gem"
    sha256 "55a5deed9ecba6037ac22bf27191e0073bd460f87291b2f384922e4b0d59511c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    bin.install "ghi"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end
