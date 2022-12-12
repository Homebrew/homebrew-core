class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "3.9.1",
      revision: "31b44067a069b7601060af337d7c27571486728f"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "deb2eb18dcb03501b396fb4abfe06d057eee46e4dc8f43cecd26d617526184c5"
    sha256 arm64_monterey: "17c719d56ee9aecf45d9f6c7de06e051a43004bd580d71d8f1beb267fae97ba7"
    sha256 arm64_big_sur:  "8ec2cbed9312f16f5e0d8410ebfe67bc45d8757d46369d62331c04639201457d"
    sha256 monterey:       "9413257d0ab186ca54af66a5818cf36182b3dd1b70ccc784c1a317b1ef128a08"
    sha256 big_sur:        "c34bc2e9ec5c607be6df1de484144189187d7aef8cec5105378a0bf42abe85b5"
    sha256 catalina:       "7909eb9eb07410a9c9155bcda4b390dd95e82f90067adc2f26e92e56ca49ec4c"
    sha256 x86_64_linux:   "4163924b949ce0760436ddaf8ed6152078ad8a6c8ccba95f22919d0ba91e9f7d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  uses_from_macos "ruby"

  # Runtime dependencies of licensed
  # https://rubygems.org/gems/licensed/versions/3.9.0/dependencies

  # bundler 2.3.26
  resource "bundler-2.3.26" do
    url "https://rubygems.org/gems/bundler-2.3.26.gem"
    sha256 "1ee53cdf61e728ad82c6dbff06cfcd8551d5422e88e86203f0e2dbe9ae999e09"
  end

  # json 2.6.2
  resource "json-2.6.2" do
    url "https://rubygems.org/gems/json-2.6.2.gem"
    sha256 "940dc787e33d7e846898724331c9463fd89b54602ff5ed6561f3eaed4168657a"
  end

  # licensee 9.15.2 -> dotenv 2.8.1
  resource "dotenv-2.8.1" do
    url "https://rubygems.org/gems/dotenv-2.8.1.gem"
    sha256 "c5944793349ae03c432e1780a2ca929d60b88c7d14d52d630db0508c3a8a17d8"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> faraday 2.7.1 -> faraday-net_http 3.0.2
  resource "faraday-net_http-3.0.2" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> faraday 2.7.1 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords-0.0.5" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> faraday 2.7.1
  resource "faraday-2.7.1" do
    url "https://rubygems.org/gems/faraday-2.7.1.gem"
    sha256 "2095ab2b0e24c0646bb06616117badf4f598770ada05e4ee2328fe0a964adff3"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2 -> addressable 2.8.1 -> public_suffix 5.0.0
  resource "public_suffix-5.0.0" do
    url "https://rubygems.org/gems/public_suffix-5.0.0.gem"
    sha256 "26ee4fbce33ada25eb117ac71f2c24bf4d8b3414ab6b34f05b4708a3e90f1c6b"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2 -> addressable 2.8.1
  resource "addressable-2.8.1" do
    url "https://rubygems.org/gems/addressable-2.8.1.gem"
    sha256 "bc724a176ef02118c8a3ed6b5c04c39cf59209607ffcce77b91d0261dbadedfa"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2 -> faraday 2.7.1 -> faraday-net_http 3.0.2
  resource "faraday-net_http-3.0.2" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2 -> faraday 2.7.1 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords-0.0.5" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2 -> faraday 2.7.1
  resource "faraday-2.7.1" do
    url "https://rubygems.org/gems/faraday-2.7.1.gem"
    sha256 "2095ab2b0e24c0646bb06616117badf4f598770ada05e4ee2328fe0a964adff3"
  end

  # licensee 9.15.2 -> octokit 4.25.1 -> sawyer 0.9.2
  resource "sawyer-0.9.2" do
    url "https://rubygems.org/gems/sawyer-0.9.2.gem"
    sha256 "fa3a72d62a4525517b18857ddb78926aab3424de0129be6772a8e2ba240e7aca"
  end

  # licensee 9.15.2 -> octokit 4.25.1
  resource "octokit-4.25.1" do
    url "https://rubygems.org/gems/octokit-4.25.1.gem"
    sha256 "c02092ee82dcdfe84db0e0ea630a70d32becc54245a4f0bacfd21c010df09b96"
  end

  # licensee 9.15.2 -> reverse_markdown 1.4.0 -> nokogiri 1.13.9 -> mini_portile2 2.8.0
  resource "mini_portile2-2.8.0" do
    url "https://rubygems.org/gems/mini_portile2-2.8.0.gem"
    sha256 "1e06b286ff19b73cfc9193cb3dd2bd80416f8262443564b25b23baea74a05765"
  end

  # licensee 9.15.2 -> reverse_markdown 1.4.0 -> nokogiri 1.13.9 -> racc 1.6.0
  resource "racc-1.6.0" do
    url "https://rubygems.org/gems/racc-1.6.0.gem"
    sha256 "2dede3b136eeabd0f7b8c9356b958b3d743c00158e2615acab431af141354551"
  end

  # licensee 9.15.2 -> reverse_markdown 1.4.0 -> nokogiri 1.13.9
  resource "nokogiri-1.13.9" do
    url "https://rubygems.org/gems/nokogiri-1.13.9.gem"
    sha256 "96f37c1baf0234d3ae54c2c89aef7220d4a8a1b03d2675ff7723565b0a095531"
  end

  # licensee 9.15.2 -> reverse_markdown 1.4.0
  resource "reverse_markdown-1.4.0" do
    url "https://rubygems.org/gems/reverse_markdown-1.4.0.gem"
    sha256 "a3305da1509ac8388fa84a28745621113e121383402a2e8e9350ba649034e870"
  end

  # licensee 9.15.2 -> rugged 1.5.0.1
  resource "rugged-1.5.0.1" do
    url "https://rubygems.org/gems/rugged-1.5.0.1.gem"
    sha256 "1d947f2b19a2bb1d9fb4e3c7d6e8b8def3ed18f5aee21a8c7f8edb3fce66010a"
  end

  # licensee 9.15.2 -> thor 1.2.1
  resource "thor-1.2.1" do
    url "https://rubygems.org/gems/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
  end

  # licensee 9.15.2
  resource "licensee-9.15.2" do
    url "https://rubygems.org/gems/licensee-9.15.2.gem"
    sha256 "4b6959b544da88499d3be0d9f486179c90b93d5049ef500ae340ac1420493ded"
  end

  # parallel 1.22.1
  resource "parallel-1.22.1" do
    url "https://rubygems.org/gems/parallel-1.22.1.gem"
    sha256 "ebdf1f0c51f182df38522f70ba770214940bef998cdb6e00f36492b29699761f"
  end

  # pathname-common_prefix 0.0.1
  resource "pathname-common_prefix-0.0.1" do
    url "https://rubygems.org/gems/pathname-common_prefix-0.0.1.gem"
    sha256 "d58feac7e5048113dd0c9630af7188baf81d83ab37fdd248fcbc63b9e5da654e"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.9 -> mini_portile2 2.8.0
  resource "mini_portile2-2.8.0" do
    url "https://rubygems.org/gems/mini_portile2-2.8.0.gem"
    sha256 "1e06b286ff19b73cfc9193cb3dd2bd80416f8262443564b25b23baea74a05765"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.9 -> racc 1.6.0
  resource "racc-1.6.0" do
    url "https://rubygems.org/gems/racc-1.6.0.gem"
    sha256 "d449a3c279026451b9fd5f34e829dc5f6e0ef6b9b472b7ff89fd3877fe8fe8cf"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.9
  resource "nokogiri-1.13.9" do
    url "https://rubygems.org/gems/nokogiri-1.13.9.gem"
    sha256 "96f37c1baf0234d3ae54c2c89aef7220d4a8a1b03d2675ff7723565b0a095531"
  end

  # reverse_markdown 2.1.1
  resource "reverse_markdown-2.1.1" do
    url "https://rubygems.org/gems/reverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  # ruby-xxHash 0.4.0.2
  resource "ruby-xxHash-0.4.0.2" do
    url "https://rubygems.org/gems/ruby-xxHash-0.4.0.2.gem"
    sha256 "201d8305ec1bd0bc32abeaecf7b423755dd1f45f4f4d02ef793b6bb71bf20684"
  end

  # thor 1.2.1
  resource "thor-1.2.1" do
    url "https://rubygems.org/gems/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
  end

  # tomlrb 2.0.3
  resource "tomlrb-2.0.3" do
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
