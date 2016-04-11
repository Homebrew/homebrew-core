class Disco < Formula
  desc "Distributed computing framework based on the MapReduce paradigm"
  homepage "http://discoproject.org/"
  url "https://github.com/discoproject/disco.git",
    :tag => "0.5.4",
    :revision => "87a755c5302625fceedbcd5a002a4757e8387996"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b675e3901b11433a43bfb6f874d09bc72ea64ad9effbcfaecf4ad97aa81eabef" => :el_capitan
    sha256 "819da8a617292acd3166651f27f0984fc21668ee659e4b2c641555d87a15d5a9" => :yosemite
    sha256 "fcbaa127872fa0949183383c8ece79bfdb87d985598dc783ecf17ed893410960" => :mavericks
  end

  option "without-test", "Skip build-time tests (not recommended)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "erlang"
  depends_on "simplejson" => :python if MacOS.version <= :leopard
  depends_on "libcmph"

  resource "nose" do
    url "https://pypi.python.org/packages/source/n/nose/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "redis" do
    url "https://pypi.python.org/packages/source/r/redis/redis-2.10.5.tar.gz"
    sha256 "5dfbae6acfc54edf0a7a415b99e0b21c0a3c27a7f787b292eea727b1facc5533"
  end

  # Upstream PR for Erlang 18.1
  patch do
    url "https://github.com/discoproject/disco/pull/637.patch"
    sha256 "97336a33ed115e476ec3aba0692236c4a9e22f17605fd9057ad415772a0f73ec"
  end

  conflicts_with "mono", :because => "both install `disco` binaries"

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"

    # Modifies config for single-node operation.
    inreplace "conf/gen.settings.sh", /(DDFS_.*_REPLICAS *= * )\d+/, "\\11"

    inreplace "Makefile" do |s|
      s.change_make_var! "prefix", prefix
      s.change_make_var! "sysconfdir", etc
      s.change_make_var! "localstatedir", var
      if build.with? "test"
        s.gsub! "(cd lib && python setup.py install --user)",
                "(cd lib && python setup.py install --user --prefix=)"
        s.gsub! "(cd lib/test && pip install nose --user && PATH=${PATH}:~/.local/bin nosetests)",
                "(cd lib/test && PATH=${PATH}:#{libexec}/vendor/bin nosetests)"
      end
    end

    system "make"

    if build.with? "test"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
      system "make", "test"
    end

    ENV.deparallelize { system "make", "install" }
    prefix.install %w[contrib doc examples]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def post_install
    # Fix the config file to point at the linked files, not into the Cellar.
    if File.read(etc/"disco/settings.py").include?(prefix)
      inreplace etc/"disco/settings.py", prefix, HOMEBREW_PREFIX
    end
  end

  def caveats
    <<-EOS.undent
      Please copy #{etc}/disco/settings.py to ~/.disco and edit it if necessary. The
      DDFS_*_REPLICA settings have been set to 1 assuming a single-machine install.
      Please see http://disco.readthedocs.org/en/latest/start/install.html for further
      instructions.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/disco client_version")
  end
end
