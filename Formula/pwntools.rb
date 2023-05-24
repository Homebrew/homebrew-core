class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://files.pythonhosted.org/packages/fa/76/aed9a42988214d6af85aa650a90be6225cfc689ad5f5c3c3b61059668f4b/pwntools-4.10.0.tar.gz"
  sha256 "588e89ea678527c0b5b6caeeee7e76e31352e78e2f1cf3dda7bc9acf526e446d"
  license "MIT"
  head "https://github.com/Gallopsled/pwntools.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "78877c2faedf3d8b52a0cdfc44b3b31f6cb0e8627e739bdd314474e44a518f68"
    sha256 cellar: :any,                 arm64_monterey: "ca344ac62a6bee0138aede9c6344430bf1ed8a5b74e49772d3aeca95d94a7e85"
    sha256 cellar: :any,                 arm64_big_sur:  "38b2b01b336e4539772637a90884f7a6fb0d49fcf24cd9578cc29bad0d8c2122"
    sha256 cellar: :any,                 ventura:        "4483deb485956a6c8b51bd1aa11589a499539d50fc7ba66af9ceb0a976abbadf"
    sha256 cellar: :any,                 monterey:       "599040d53abe961a13076aa3ac7632a24fff260bb4739417d96594bdeb0ab505"
    sha256 cellar: :any,                 big_sur:        "a856e58523684e2be5047f7aa07851f668bfd751f6dd0f726c22dc8d788bd51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65bb063987a6cc7464fcf1b5e8101a162e31145265b886b7a134e57dc524843c"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "unicorn"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "moreutils", because: "both install an `errno` executable"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/a6/6f/6d98f636aba7f064e235b345667e50219b7a53b7ef8871ed7ac6bc50d3fd/capstone-5.0.0rc2.tar.gz"
    sha256 "48f22d674d84f01c2aa7c7dcfe8ba5e4269708ba7463aac9f8df6e9f2bc60740"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "colored-traceback" do
    url "https://files.pythonhosted.org/packages/9a/8b/0a4e2a8cdc14279b265532f11c9cb75396880e6295c99a0bed7281b6076a/colored-traceback-0.3.0.tar.gz"
    sha256 "6da7ce2b1da869f6bb54c927b415b95727c4bb6d9a84c4615ea77d9872911b05"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/e8/53/e614a5b7bcc658d20e6eff6ae068863becb06bf362c2f135f5c290d8e6a2/paramiko-3.1.0.tar.gz"
    sha256 "6950faca6819acd3219d4ae694a23c7a87ee38d084f70c1724b0c0dbb8b75769"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/56/e0/bcff74e68f8b71f4b9ce9e79b533df6d1ecff33c856fb93aab7e8a7c8d82/plumbum-1.8.1.tar.gz"
    sha256 "88a40fc69247d0cd585e21ca169b3820f46c484535102e16455d2202727bb37b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ropgadget" do
    url "https://files.pythonhosted.org/packages/9a/f3/b9d945c624b6df35a36d52b97719ba93c0d81484a5b51c3829ac7caf620f/ROPGadget-7.3.tar.gz"
    sha256 "4078e70601a2dc869123dfa352812dcc44767a4bbde482b7059d34b33bb67850"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/0f/e0/a584823afecc5d8a0c18c46da4e028876e3e34946e6e3b2c3d430cd19b18/rpyc-5.3.1.tar.gz"
    sha256 "f2233174879faf18ae266437d5a65511ce46c817cec4edc1344f036758cfbf52"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https://files.pythonhosted.org/packages/64/c7/1a571a06adda2a9802e21d84398c5547761cb28b22f59a2c5db62bf23887/unicorn-2.0.1.post1.tar.gz"
    sha256 "7fc69523eb83b4c8abc7cb4410ca21875e066c34b7afe998f59481e830d28e56"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    ENV["LIBUNICORN_PATH"] = Formula["unicorn"].opt_lib
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      # Use env scripts to help unicorn python bindings dynamically load shared library
      f.write_env_script libexec/"bin"/f.basename, LIBUNICORN_PATH: Formula["unicorn"].opt_lib
    end
    bash_completion.install "extra/bash_completion.d/pwn"
    zsh_completion.install "extra/zsh_completion/_pwn"
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
