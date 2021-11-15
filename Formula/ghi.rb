class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.2.0.tar.gz"
  sha256 "ffc17cfbdc8b88bf208f5f762e62c211bf8fc837f447354ad53cce39b1400671"
  license "MIT"
  revision 4
  head "https://github.com/stephencelis/ghi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "320e13830aac81ab0bcbef032e548f6a5f9bf71ce713d7dab24fc813087f4d4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "78e10bdfae403bb4ca2a2d6208d7df3cd84f321711ca310ded6b00850a69e6bf"
    sha256 cellar: :any_skip_relocation, catalina:      "36449d0c0fc0a544808178745ce7a846dfd905cf5fc2489feaa2a70d26346041"
    sha256 cellar: :any_skip_relocation, mojave:        "b6dcd03ae7705b3a3648c6df15b9e451397cd81e41acc5c5f8444796c747c580"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9289e061f8a249130950ec212042e3d9adfaa96e3591f0eb2d6038c28ff0e6d6"
    sha256 cellar: :any_skip_relocation, sierra:        "d2b59c4b0326bd4d4b2de6da0310e1d5228cc63d57adb9eb37c5f5c5a9471131"
    sha256 cellar: :any_skip_relocation, el_capitan:    "d2b59c4b0326bd4d4b2de6da0310e1d5228cc63d57adb9eb37c5f5c5a9471131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31384887e9ccf6bca66b79aa8e0df82a6a67ba9e8849dbf0b0c0e0db75c944d7"
    sha256 cellar: :any_skip_relocation, all:           "3bf94079d3d55b9bf8e901bf7791937119d4636661f876e411139e7ab09e7658"
  end

  uses_from_macos "ruby"

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
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    bin.install "ghi"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end
