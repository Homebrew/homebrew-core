class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.2.0.tar.gz"
  sha256 "ffc17cfbdc8b88bf208f5f762e62c211bf8fc837f447354ad53cce39b1400671"
  revision 4
  head "https://github.com/stephencelis/ghi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9289e061f8a249130950ec212042e3d9adfaa96e3591f0eb2d6038c28ff0e6d6" => :high_sierra
    sha256 "d2b59c4b0326bd4d4b2de6da0310e1d5228cc63d57adb9eb37c5f5c5a9471131" => :sierra
    sha256 "d2b59c4b0326bd4d4b2de6da0310e1d5228cc63d57adb9eb37c5f5c5a9471131" => :el_capitan
  end

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
