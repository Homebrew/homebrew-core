class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "4.4.0",
      revision: "0f5e5a1d289665e8a3d7133cba6c6f3a15359ecb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e29a894119212da640f791ca9549c8e0f287748555bd061ba03aee8a70c1b6a1"
    sha256 cellar: :any,                 arm64_monterey: "37443d189f124d38d0b6eedab9faa1bc867f2e3a188d28f08127eeb9e4e73dc5"
    sha256 cellar: :any,                 arm64_big_sur:  "3ead2b4adf3be289685403b317be482d00bf0818f566afb449be4de75e15c022"
    sha256 cellar: :any,                 ventura:        "b3f32e768216de09fa52dd2fe0a0b9f2bacb752809e2b53397e020c2f1a53295"
    sha256 cellar: :any,                 monterey:       "423470bea18004c09b236e8f4e8d044ee3d472ad481ec609f3e95867b99fc1cd"
    sha256 cellar: :any,                 big_sur:        "e1e5c8de404141168428d94c4e6ad62be08d4cb865041de59333cb95f97e2511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3251f273f72710bb10ce577d1009df603b743eab3b00a198173d164791a9301f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "libffi"

  on_linux do
    depends_on "openssl@3"
  end

  # Runtime dependencies of licensed
  # https://rubygems.org/gems/licensed/versions/4.4.0/dependencies

  # json 2.6.3
  resource "json" do
    url "https://rubygems.org/gems/json-2.6.3.gem"
    sha256 "86aaea16adf346a2b22743d88f8dcceeb1038843989ab93cda44b5176c845459"
  end

  # licensee 9.16.0 -> dotenv 2.8.1
  resource "dotenv" do
    url "https://rubygems.org/gems/dotenv-2.8.1.gem"
    sha256 "c5944793349ae03c432e1780a2ca929d60b88c7d14d52d630db0508c3a8a17d8"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> faraday 2.7.5 -> faraday-net_http 3.0.2
  resource "faraday-net_http" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> faraday 2.7.5 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # llicensee 9.16.0 -> octokit 6.1.1 -> faraday 2.7.5
  resource "faraday" do
    url "https://rubygems.org/gems/faraday-2.7.5.gem"
    sha256 "e4fde719d3b7d5c4513459cd1b72e689aac09d4673293ac6854a7cb804f143b9"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2 -> addressable 2.8.4 -> public_suffix 5.0.1
  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-5.0.1.gem"
    sha256 "65603917ff4ecb32f499f42c14951aeed2380054fa7fc51758fc0a8d455fe043"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2 -> addressable 2.8.4
  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.4.gem"
    sha256 "40a88af5285625b7fb14070e550e667d5b0cc91f748068701b4d897cacda4897"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2 -> faraday 2.7.5 -> faraday-net_http 3.0.2
  resource "faraday-net_http" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2 -> faraday 2.7.5 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2 -> faraday 2.7.5
  resource "faraday" do
    url "https://rubygems.org/gems/faraday-2.7.5.gem"
    sha256 "e4fde719d3b7d5c4513459cd1b72e689aac09d4673293ac6854a7cb804f143b9"
  end

  # licensee 9.16.0 -> octokit 6.1.1 -> sawyer 0.9.2
  resource "sawyer" do
    url "https://rubygems.org/gems/sawyer-0.9.2.gem"
    sha256 "fa3a72d62a4525517b18857ddb78926aab3424de0129be6772a8e2ba240e7aca"
  end

  # licensee 9.16.0 -> octokit 6.1.1
  resource "octokit" do
    url "https://rubygems.org/gems/octokit-6.1.1.gem"
    sha256 "920e4a9d820205f70738f58de6a7e6ef0e2f25b27db954b5806a63105207b0bf"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.15.2 -> mini_portile2 2.8.2
  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.8.2.gem"
    sha256 "46b2d244cc6ff01a89bf61274690c09fdbdca47a84ae9eac39039e81231aee7c"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.15.2 -> racc 1.6.2
  resource "racc" do
    url "https://rubygems.org/gems/racc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.15.2
  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.15.2.gem"
    sha256 "20dc800b8fbe4c4f4b5b164e6aa3ab82a371bcb27eb685c166961c34dd8a22d7"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1
  resource "reverse_markdown" do
    url "https://rubygems.org/gems/reverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  # licensee 9.16.0 -> rugged 1.6.3
  resource "rugged" do
    url "https://rubygems.org/gems/rugged-1.6.3.gem"
    sha256 "362631de8dc6f1074242f21e01148ac70b7fe8cdb17f85eee91d4ea83457cb04"
  end

  # licensee 9.16.0 -> thor 1.2.2
  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  # licensee 9.16.0
  resource "licensee" do
    url "https://rubygems.org/gems/licensee-9.16.0.gem"
    sha256 "7b1693639019dbb1d3e020d72c4470ca84da3cfc67e4d6da1d1cdcb736d09044"
  end

  # parallel 1.23.0
  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.23.0.gem"
    sha256 "27154713ad6ef32fa3dcb7788a721d6c07bca77e72443b4c6080a14145288c49"
  end

  # pathname-common_prefix 0.0.1
  resource "pathname-common_prefix" do
    url "https://rubygems.org/gems/pathname-common_prefix-0.0.1.gem"
    sha256 "d58feac7e5048113dd0c9630af7188baf81d83ab37fdd248fcbc63b9e5da654e"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.15.2 -> mini_portile2 2.8.2
  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.8.2.gem"
    sha256 "46b2d244cc6ff01a89bf61274690c09fdbdca47a84ae9eac39039e81231aee7c"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.15.2 -> racc 1.6.2
  resource "racc" do
    url "https://rubygems.org/gems/racc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.15.2
  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.15.2.gem"
    sha256 "20dc800b8fbe4c4f4b5b164e6aa3ab82a371bcb27eb685c166961c34dd8a22d7"
  end

  # reverse_markdown 2.1.1
  resource "reverse_markdown" do
    url "https://rubygems.org/gems/reverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  # ruby-xxHash 0.4.0.2
  resource "ruby-xxHash" do
    url "https://rubygems.org/gems/ruby-xxHash-0.4.0.2.gem"
    sha256 "201d8305ec1bd0bc32abeaecf7b423755dd1f45f4f4d02ef793b6bb71bf20684"
  end

  # thor 1.2.2
  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  # tomlrb 2.0.3
  resource "tomlrb" do
    url "https://rubygems.org/gems/tomlrb-2.0.3.gem"
    sha256 "c2736acf24919f793334023a4ff396c0647d93fce702a73c9d348deaa815d4f7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      system "gem", "install", r.cached_download, *args
    end

    system "gem", "build", "licensed.gemspec"
    system "gem", "install", "licensed-#{version}.gem"
    bin.install libexec/"bin/licensed"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    shims_references = Dir[
      libexec/"extensions/**/rugged-*/gem_make.out",
      libexec/"extensions/**/rugged-*/mkmf.log",
      libexec/"gems/rugged-*/vendor/libgit2/build/CMakeCache.txt",
      libexec/"gems/rugged-*/vendor/libgit2/build/**/CMakeFiles/**/*",
    ].select { |f| File.file? f }
    inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath/".licensed.yml").write <<~EOS
      name: 'test'
      allowed:
        - mit
    EOS

    assert_match "Caching dependency records for test",
                        shell_output(bin/"licensed cache")
  end
end
