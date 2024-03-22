class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.7.tar.gz"
  sha256 "88c52fe475308ee95f560fd7cf68c75bc6e9a6abf56be7fed203a7f762fe7ab2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe37256db6d4ffd8e9df71494335491d7a1086afcaa3a57b8a14c3785f1f4f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb4393aa7f6111f06b5c4173425409030be3f2254f9d0b4fc01526e0e706326c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c80d981c1bb95432d864eaf4f96f2ccb85905502937e8fda2d6d659541adf71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b692a656f344818c273c9e737b1b1b5554b463e01a0d2b59f79dbbb11559e3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d5231427d5925df8a938e51f62a2c9bd0c2b8e10263a18a63e5f074b91d5c97"
    sha256 cellar: :any_skip_relocation, ventura:        "2344e89ad92c8a86a740bedd60e1c6cc9308950ac16830acbf5e4515b87726b7"
    sha256 cellar: :any_skip_relocation, monterey:       "8014f699a3441f6044f26e72845dad37f9f608bb079eaf27c9f53b8524a61f5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc1a81595404f2699a2e3c47f13f88e7127dce248f85fc17e02df2b6a36d5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f766bffd7355a05bd8d6101ee22f7f47b943862e6158dcfadec0d59316a13cc"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
