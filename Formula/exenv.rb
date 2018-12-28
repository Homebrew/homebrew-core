class Exenv < Formula
  desc "Elixir version manager"
  homepage "https://github.com/exenv/exenv"
  url "https://github.com/exenv/exenv/archive/v1.1.1.tar.gz"
  sha256 "d8318ed11ddf6f8a215f982677f4166035efe02bc67993b216d01dec11add2ef"
  head "https://github.com/exenv/exenv.git"

  depends_on "elixir-build"

  def install
    inreplace "libexec/exenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/exenv.d", ":#{HOMEBREW_PREFIX}/etc/exenv.d\\0"
      end
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/exenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "exenv.d"]
  end

  test do
    shell_output("eval \"$(#{bin}/exenv init -)\"")
  end
end
