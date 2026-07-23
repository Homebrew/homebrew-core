class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/drazisil/ghi"
  url "https://github.com/drazisil/ghi/archive/refs/tags/1.2.1.tar.gz"
  sha256 "83fbc4918ddf14df77ef06b28922f481747c6f4dc99b865e15d236b1db98c0b8"
  license "MIT"
  head "https://github.com/drazisil/ghi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1aae6d56ac822129634f25eb1d4c79c36f4ca5c1995262571d32eb9011bb329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1aae6d56ac822129634f25eb1d4c79c36f4ca5c1995262571d32eb9011bb329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1aae6d56ac822129634f25eb1d4c79c36f4ca5c1995262571d32eb9011bb329"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1aae6d56ac822129634f25eb1d4c79c36f4ca5c1995262571d32eb9011bb329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0df5f7842e1c23c55436dfb9943aa7ee93679f7ce59910a2f5d370f9e29e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d0df5f7842e1c23c55436dfb9943aa7ee93679f7ce59910a2f5d370f9e29e7e"
  end

  uses_from_macos "ruby"

  resource "pygments.rb" do
    url "https://rubygems.org/gems/pygments.rb-2.3.0.gem"
    sha256 "4c41c8baee10680d808b2fda9b236fe6b2799cd4ce5c15e29b936cf4bf97f510"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
                    "--no-document", "--install-dir", libexec
    end
    bin.install "ghi"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/ghi.1"
  end

  test do
    system bin/"ghi", "--version"
  end
end
