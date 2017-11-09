class Dryrun < Formula
    desc ":cloud: Try the demo project of any Android Library"
    homepage "https://github.com/cesarferreira/dryrun/blob/master/README.md"
    url "https://github.com/cesarferreira/dryrun/archive/v1.0.0.tar.gz"
    sha256 "220a07109bc5f4a7ef2561a3f55a01c67de1c4c63c59047d10c811d093e26414"

    def install
        ENV["GEM_HOME"] = libexec
        system "gem", "build", "dryrun.gemspec"
        system "gem", "install", "dryrun"

        bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
        bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    end

    test do
        system "false"
    end
end
