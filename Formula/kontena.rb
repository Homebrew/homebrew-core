class Kontena < Formula
  desc "Command-line client for Kontena container orchestration platform"
  homepage "https://kontena.io/"
  head "https://github.com/kontena/kontena.git"

  stable do
    url "https://github.com/kontena/kontena.git",
        :tag      => "v1.5.4",
        :revision => "8d68c77012f4de770c9e14653d5db63c64fac83f"

    resource "clamp" do
      url "https://rubygems.org/gems/clamp-1.2.1.gem"
      sha256 "cd041aaf6b4dfd2239cdcfe2c72084d0536b1e7630236353a1d00b0a2e15ca68"
    end

    resource "equatable" do
      url "https://rubygems.org/gems/equatable-0.5.0.gem"
      sha256 "fdc8669f9bdc993be5cb6c08ec86343a7e87756e33c68ff5f63dfaa9e44f55ea"
    end

    resource "excon" do
      url "https://rubygems.org/gems/excon-0.60.0.gem"
      sha256 "cc758304b98d5c1f1bef29d306870a1892bf8c3cf66d95e21a99e076b4a3bce7"
    end

    resource "hash_validator" do
      url "https://rubygems.org/gems/hash_validator-0.8.0.gem"
      sha256 "3e19efbfac9dd9842a3f4b6695bf74fcc7aa0681de733fda9d6bc1548ed04264"
    end

    resource "hitimes" do
      url "https://rubygems.org/gems/hitimes-1.2.6.gem"
      sha256 "5939da5baf4bed890b481d77dc37d481297d0f06f1d2569f4c5c9a2112144218"
    end

    resource "kontena-websocket-client" do
      url "https://rubygems.org/gems/kontena-websocket-client-0.1.1.gem"
      sha256 "692804a448d4ac6474d5091c5b74278f5f2f0efd9b2616ebd9a415a18e0f3d96"
    end

    resource "liquid" do
      url "https://rubygems.org/gems/liquid-4.0.0.gem"
      sha256 "5ef4c157436096e6dac49f8b1edc0eb6c8f3b55fc8ffed5d1949a5ca9f04ca9d"
    end

    resource "necromancer" do
      url "https://rubygems.org/gems/necromancer-0.4.0.gem"
      sha256 "7fab7bc465a634365d354341a0f7a57a6928b7b06777442c3b377fb36783366d"
    end

    resource "opto" do
      url "https://rubygems.org/gems/opto-1.8.7.gem"
      sha256 "1e4c231992665fc8fef26f76c8b0d0a7b5e885c5883ba9d8244c6aa153809c7b"
    end

    resource "pastel" do
      url "https://rubygems.org/gems/pastel-0.7.2.gem"
      sha256 "e1d21dd8fb965e5052d1b16164a777fc450c6e187bf199f833a9de3f5303c3f9"
    end

    resource "retriable" do
      url "https://rubygems.org/gems/retriable-2.1.0.gem"
      sha256 "c1e309cd29ca451e9e8aea7685368db0da490d519ced16f79867fae12b9e4384"
    end

    resource "ruby_dig" do
      url "https://rubygems.org/gems/ruby_dig-0.0.2.gem"
      sha256 "e95668c4140f17b9ee0742caaa77e8044bc9f2d990441e846afd57dd8aab97e1"
    end

    resource "semantic" do
      url "https://rubygems.org/gems/semantic-1.6.1.gem"
      sha256 "3cdbb48f59198ebb782a3fdfb87b559e0822a311610db153bae22777a7d0c163"
    end

    resource "timers" do
      url "https://rubygems.org/gems/timers-4.1.2.gem"
      sha256 "a7a7148409d5d6a7c04624277f4cc99f7748b40be394afcc4187ada73c2a5d71"
    end

    resource "tty-color" do
      url "https://rubygems.org/gems/tty-color-0.4.2.gem"
      sha256 "2aa4da523710daf3e953f6c58145f5c9338feca76b0d2adfe25a4259cbc4b2c4"
    end

    resource "tty-cursor" do
      url "https://rubygems.org/gems/tty-cursor-0.5.0.gem"
      sha256 "bffb2e54bec3bbb22e4a845ebc0ca8f6afbbc1ce506d2e316955cdb8387eaf76"
    end

    resource "tty-prompt" do
      url "https://rubygems.org/gems/tty-prompt-0.14.0.gem"
      sha256 "be924c6dd8bd30cc50cfab131eb724e1b4adbda2fb3087af6d6f5539d4a3a032"
    end

    resource "tty-reader" do
      url "https://rubygems.org/gems/tty-reader-0.2.0.gem"
      sha256 "895d35b6c1e0a2fa8711b48968ae78a4023a770875960060f31055a3af9b57fd"
    end

    resource "tty-screen" do
      url "https://rubygems.org/gems/tty-screen-0.6.4.gem"
      sha256 "7b190d049dfc723ab4c69a2d2e494a4d1478694001587fb20575499cef0038a6"
    end

    resource "tty-table" do
      url "https://rubygems.org/gems/tty-table-0.9.0.gem"
      sha256 "03fd0edaf04395d124a58ae0c876a1a2d3ce1aec53e0763a581695cbde5477ee"
    end

    resource "unicode-display_width" do
      url "https://rubygems.org/gems/unicode-display_width-1.1.3.gem"
      sha256 "1d6247805b2431fd3d27614f6e0c38665b068bfc3a58cf89f08b7f107daf48e4"
    end

    resource "unicode_utils" do
      url "https://rubygems.org/gems/unicode_utils-1.4.0.gem"
      sha256 "b922d0cf2313b6b7136ada6645ce7154ffc86418ca07d53b058efe9eb72f2a40"
    end

    resource "verse" do
      url "https://rubygems.org/gems/verse-0.5.0.gem"
      sha256 "4c8af6322b91e115a772af1acdf99952e391ad14890577674e11e52d474af2e0"
    end

    resource "websocket-driver" do
      url "https://rubygems.org/gems/websocket-driver-0.6.5.gem"
      sha256 "b4a4e0c75eae9e85ceb248d4dc13519da581452767dcd5126c1452ea052183a4"
    end

    resource "websocket-extensions" do
      url "https://rubygems.org/gems/websocket-extensions-0.1.3.gem"
      sha256 "e0886634e49a5d0a790b43d49286af0f47b86636257843cb539e8ce64e6e9a0c"
    end

    resource "wisper" do
      url "https://rubygems.org/gems/wisper-2.0.0.gem"
      sha256 "6d8623c76943612e8db81862af7eb20f5a8ad631fe1857d9f7ced97e87e5222b"
    end
  end

  bottle do
    sha256 "37d589d3a85402e006dd3dd7a75fbcb010f0d4984a4080f7d5eeffcead791631" => :mojave
    sha256 "3cf1b8ba751a53d3db948cd92a24e6e7ccf50f92be34df053c44bcfd42ce1b1a" => :high_sierra
    sha256 "52ed5b767e77161f2e8857e34e22f7e86db5ff35a5ad45724399ec60ccfe5f41" => :sierra
    sha256 "4f875785a3849869b78bf9788d7c3949dd20ce8fdb027f1e0380ec7f8f190719" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    ENV["GEM_HOME"] = libexec

    cd "cli" do
      system "gem", "build", "--norc", "kontena-cli.gemspec"

      if build.head?
        system "gem", "install", Dir["kontena-cli-*.gem"].first,
               "--no-document", "--norc", "--install-dir", libexec
      else
        resources.each do |r|
          r.verify_download_integrity(r.fetch)
          system "gem", "install", r.cached_download, "--ignore-dependencies",
                 "--no-document", "--norc", "--install-dir", libexec
        end

        system "gem", "install", "--ignore-dependencies", "--norc",
               "--no-document", "kontena-cli-#{version}.gem"
      end
    end

    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    env = { :GEM_PATH => libexec, :KONTENA_EXTRA_BUILDTAGS => "homebrew" }

    if build.head?
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
      env[:KONTENA_EXTRA_BUILDTAGS].concat ",head-#{commit}"
    end

    (bin/"kontena").write_env_script(libexec/"bin/kontena", env)

    bash_completion.install "cli/lib/kontena/scripts/kontena.bash" => "kontena"
    zsh_completion.install "cli/lib/kontena/scripts/kontena.zsh" => "_kontena"
  end

  test do
    assert_match "+homebrew", shell_output("#{bin}/kontena --version")
    assert_match "login", shell_output("#{bin}/kontena complete kontena master")
    test_yaml = "stack: test/test\nversion: 0.1.0\nservices:\n  redis:\n    image: redis:latest\n"
    (testpath/"kontena.yml").write(test_yaml)
    output = shell_output("#{bin}/kontena stack validate --format api-json")
    assert_match "\"stack\": \"test/test\"", output
    assert_match "\"expose\": null", output
    assert_match "NAME", shell_output("#{bin}/kontena master list")
  end
end
