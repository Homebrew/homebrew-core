class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  # pull from git tag as gemspec uses `git ls-files`
  # For versions following v7.1.0, may be able to remove 4cac18e5 patch.
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.2.1",
      revision: "00b04cb91e8ec9021c939ccfceb69d4047f4c8ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4cb34b2334a48e59f4f6e345ec724015ce1fcbef28863c8a7f1e45b7d851c3a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79f4e016ce9a7863fb1a8af0b6d05fbddda4d7bd73e0eb88e5fcdc167c0576be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f393a73ba947c00a0a5c85d6ad643711f88b8432a8b02240e95fbc6897ae7b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67039d8af9f8d4cb432b87d702b63596c32a3df5ee9873c827a2d65c73c387c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94181e5784a74c2ce1c6ef53ca3036abfdacaf79a44c4cc0a36bacd316e57f67"
    sha256 cellar: :any_skip_relocation, sonoma:         "77ac7350b5c910ef956d6fac8ffe98232bce930476f6b462e8fcf31379e2254d"
    sha256 cellar: :any_skip_relocation, ventura:        "1c03235aa33eb51bee7344de88c4e16808a8f6283a0845c873784d37ec14a406"
    sha256 cellar: :any_skip_relocation, monterey:       "076664ad53828cc598b55fa5dc0177bc57fd2a808d0c0ab20d85fac4e98dd3f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "51eb4b6c26c2d5088c2f382ffff159e64d3c54b1c1cecc539200024f31217171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8093e28fbd29078317ad298dd33971cd32950e5c56204eb2bff5de074b6ed9"
  end

  depends_on "ruby"

  # Ruby 3.3 introduced changes that mean we now need to manually require
  # racc. See https://bugs.ruby-lang.org/issues/19702 for details.
  # LicenseFinder versions after v7.1.0 may address this requirement.
  patch do
    url "https://github.com/pivotal/LicenseFinder/commit/4cac18e5c7a48f72700b8de4db97d3150637a20d.patch?full_index=1"
    sha256 "7a7a9b201cd34a5f868901841ba5f144f0e75580664c8ec024792449348f5875"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec/"bin/license_finder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["GEM_PATH"] = ENV["GEM_HOME"] = testpath
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'license_finder', '#{version}'
      gem 'racc'
    EOS

    system "bundle", "install"
    assert_match "license_finder, #{version}, #{license}",
                  shell_output(bin/"license_finder", 1)
  end
end
