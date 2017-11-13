class Dryrun < Formula
  desc ":cloud: Try the demo project of any Android Library"
  homepage "https://github.com/cesarferreira/dryrun/blob/master/README.md"
  url "https://github.com/cesarferreira/dryrun/archive/v1.0.0.tar.gz"
  sha256 "220a07109bc5f4a7ef2561a3f55a01c67de1c4c63c59047d10c811d093e26414"

  depends_on :ruby => "1.8"

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
        "--install-dir", libexec
    end
    system "gem", "build", "dryrun.gemspec"
    system "gem", "install", "--ignore-dependencies", "dryrun-#{version}.gem"
    bin.install libexec/"bin/dryrun"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    assert_equal "1.0.0\n", pipe_output("#{bin}/dryrun -v")
  end
end
