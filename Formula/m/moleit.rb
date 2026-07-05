class MoleIt < Formula
  desc 'CLI tool for scaffolding C and C++ projects, inspired by cargo init'
  homepage 'https://github.com/Jayesh-Dev21/MoleIt'
  url 'https://moleit.vercel.app/rel/v0.1.0.tar.gz'
  sha256 'a352bd2143aa415e31caa9118602c13a2ccc20d3d34b9c32f44380b0b612c4eb'
  license 'MIT'

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'fmt'

  def install
    system 'cmake', '-S', '.', '-B', 'build', '-G', 'Ninja',
           '-DCMAKE_BUILD_TYPE=Release',
           "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system 'cmake', '--build', 'build', '-j'
    system 'cmake', '--install', 'build'
  end

  test do
    system "#{bin}/moleit", '--version'
  end
end
