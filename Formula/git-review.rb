class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://git.openstack.org/cgit/openstack-infra/git-review"
  url "https://files.pythonhosted.org/packages/2c/e6/e4f1b999af2493a5cc5e050f0869b29f30914f94016abf48c77c6307745b/git-review-1.28.0.tar.gz"
  sha256 "8e3aabb7b9484063e49c2504d137609401e32ad5128ff2a5cf43e98d5d3dc15a"
  head "https://git.openstack.org/openstack-infra/git-review.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e5d4f99cf65a2e0454ab13fdd300795cf4a9da707799eff38edcb2340e3c63" => :catalina
    sha256 "a12f62ba8ae2ec1f8247e21d1bf99eb6b2e07e801518ec65fa190558c5e36b14" => :mojave
    sha256 "9ddf50178ac4c2bc4f8c5bb102eb36d20ad3c52d5ed2569adc08fb66c7f91bea" => :high_sierra
    sha256 "a1cd9a36808cccc52105851a8f09ff29c82469d14701aad6c7ea06abe17c8a5f" => :sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/97/10/92d25b93e9c266c94b76a5548f020f3f1dd0eb40649cb1993532c0af8f4c/requests-2.20.0.tar.gz"
    sha256 "99dcfdaaeb17caf6e526f32b6a7b780461512ab3f1d992187801694cba42770c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/a5/74/05ffd00b4b5c08306939c485869f5dc40cbc27357195b0a98b18e4c48893/urllib3-1.24.tar.gz"
    sha256 "41c3db2fc01e5b907288010dec72f9d0a74e37d6994e6eb56849f59fea2265ae"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    man1.install gzip("git-review.1")

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/homebrew.github.io"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
