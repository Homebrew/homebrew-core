class Ndenv < Formula
  desc "Node version manager"
  homepage "https://github.com/riywo/ndenv"
  url "https://github.com/riywo/ndenv/archive/v0.4.0.tar.gz"
  sha256 "1a85e4c0c0eee24d709cbc7b5c9d50709bf51cf7fe996a1548797a4079e0b6e4"
  license "MIT"
  head "https://github.com/riywo/ndenv.git"

  bottle :unneeded

  depends_on "node-build"

  def install
    inreplace "libexec/ndenv" do |s|
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/ndenv.d", \
            ":#{HOMEBREW_PREFIX}/etc/ndenv.d\\0"
      end
    end

    if build.head?
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/, \
          %Q(\\1"\\2-g#{Utils.git_short_head}")
    end

    prefix.install "bin", "completions", "libexec"
    system "#{bin}/ndenv", "rehash"
  end

  test do
    shell_output "eval \"$(#{bin}/ndenv init -)\" && ndenv versions"
  end
end
